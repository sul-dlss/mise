import React from 'react';
import PropTypes from 'prop-types';
import mapValues from 'lodash/mapValues';
import Mirador from 'mirador/dist/es/src/index';
import miradorImageToolsPlugin from 'mirador-image-tools/es/plugins/miradorImageToolsPlugin';
import miradorAnnotationsPlugins from 'mirador-annotations/es';
import { addResource, importMiradorState } from 'mirador/dist/es/src/state/actions';
import {
  getExportableState, getManifestTitle, getManifestProvider,
  getManifestThumbnail, getManifestoInstance, getCanvases,
} from 'mirador/dist/es/src/state/selectors';
import AnnototAdapter from 'mirador-annotations/es/AnnototAdapter';
import { diff } from 'deep-object-diff';
import { isEmpty, omit, omitBy } from 'lodash';

/** */
class Viewer extends React.Component {
  constructor() {
    super();
    this.state = {
      viewerState: {},
    };
  }

  /** */
  componentDidMount() {
    const {
      annototEndpointUrl, config, enabledPlugins, initialState,
      viewerStateSelector, projectResourcesUrl,
    } = this.props;

    delete config.export;

    let annotationsConfig = {};

    if (annototEndpointUrl) {
      annotationsConfig = {
        annotation: {
          adapter: (canvasId) => new AnnototAdapter(canvasId, annototEndpointUrl),
        },
      };
    }

    const instance = Mirador.viewer(
      { ...config, ...annotationsConfig },
      [
        ...((enabledPlugins.includes('imageTools') && miradorImageToolsPlugin) || []),
        ...((enabledPlugins.includes('annotations') && miradorAnnotationsPlugins) || []),
      ],
    );

    if (initialState) {
      instance.store.dispatch(
        importMiradorState(
          {
            ...initialState,
            config: instance.store.getState().config,
          },
        ),
      );
    }

    if (projectResourcesUrl) instance.store.dispatch(addResource(projectResourcesUrl));
    if (viewerStateSelector) {
      instance.store.subscribe(() => {
        const viewerState = instance.store.getState();
        const exportableState = getExportableState(viewerState);
        this.setState({ viewerState: exportableState });
        const inputElement = document.querySelector(viewerStateSelector);
        const __mise_cache__ = { // eslint-disable-line camelcase
          manifests: mapValues(viewerState.manifests, m => this.getManifestCache(viewerState, m)),
        };
        if (inputElement) {
          inputElement.value = JSON.stringify(
            {
              ...exportableState,
              __mise_cache__, // eslint-disable-line camelcase
            },
          );
        }
      });
    }

    window.addEventListener('beforeunload', this.checkUnsavedChanges, false);
    window.addEventListener('turbolinks:click', this.checkUnsavedChanges, false);
  }

  /** */
  componentWillUnmount() {
    window.removeEventListener('beforeunload', this.checkUnsavedChanges, false);
    window.removeEventListener('turbolinks:click', this.checkUnsavedChanges, false);
  }

  getManifestCache = (state, manifest) => {
    if (!manifest.json) return {};

    const manifestId = manifest.id;
    const manifesto = getManifestoInstance(state, { manifestId });
    const isCollection = (
      manifesto || { isCollection: () => false }
    ).isCollection();
    const size = isCollection
      ? manifesto.getTotalItems()
      : getCanvases(state, { manifestId }).length;

    return {
      '@type': manifest.json['@type'],
      itemcount: size,
      label: getManifestTitle(state, { manifestId }),
      provider: getManifestProvider(state, { manifestId }),
      thumbnail: getManifestThumbnail(state, { manifestId }),
    };
  }

  checkUnsavedChanges = (event) => {
    const { viewerState } = this.state;
    const { persistedStateSelector } = this.props;
    // Get current persisted value of DOM element instead of using what is
    // stuffed in props since the former may have been updated by a
    // user-initiated save operation
    const persistedState = document.querySelector(persistedStateSelector).value;

    // Diff the two Mirador states
    const difference = diff(persistedState, viewerState);
    // Remove known false positives from diff object
    const filtered = omit(difference, ['__mise_cache__', 'config.annotation', 'config.export', 'workspace.id']);
    // Remove empty top-level objects created by removing false positives
    const changes = omitBy(filtered, isEmpty);

    if (!isEmpty(changes)) {
      console.dir(changes);
      event.preventDefault();
      event.returnValue = 'If you navigate away from the workspace now, changes you have made will be lost. Are you sure you want to navigate away?'; // eslint-disable-line no-param-reassign
      return event.returnValue;
    } else {
      console.log('client state:');
      console.dir(viewerState);
      console.log('server state:');
      console.dir(persistedState);
    }
    return true;
  }

  /** */
  render() {
    const { config } = this.props;
    return <div id={config.id} />;
  }
}

Viewer.propTypes = {
  annototEndpointUrl: PropTypes.string,
  config: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  enabledPlugins: PropTypes.array, // eslint-disable-line react/forbid-prop-types
  initialState: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  persistedStateSelector: PropTypes.string,
  projectResourcesUrl: PropTypes.string,
  viewerStateSelector: PropTypes.string,
};

Viewer.defaultProps = {
  annototEndpointUrl: null,
  config: {},
  enabledPlugins: [],
  initialState: null,
  persistedStateSelector: null,
  projectResourcesUrl: null,
  viewerStateSelector: null,
};

export default Viewer;
