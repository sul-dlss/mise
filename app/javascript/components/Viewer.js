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
      currentState: {},
    };
  }

  /** */
  componentDidMount() {
    const {
      annototEndpointUrl, config, enabledPlugins, state, updateStateSelector, projectResourcesUrl,
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

    if (state) {
      instance.store.dispatch(
        importMiradorState(
          {
            ...state,
            config: instance.store.getState().config,
          },
        ),
      );
    }

    if (projectResourcesUrl) instance.store.dispatch(addResource(projectResourcesUrl));
    if (updateStateSelector) {
      instance.store.subscribe(() => {
        const currentState = instance.store.getState();
        const exportableState = getExportableState(currentState);
        this.setState({ currentState: exportableState });
        const inputElement = document.querySelector(updateStateSelector);
        const __mise_cache__ = { // eslint-disable-line camelcase
          manifests: mapValues(currentState.manifests, m => this.getManifestCache(currentState, m)),
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
    const { currentState } = this.state;
    const { state: initialState, saveInProgressSelector } = this.props;
    // Skip checking for unsaved changes because a save is in progress
    if (document.querySelector(saveInProgressSelector).value === 'true') return true;

    const expectedDiffPaths = ['__mise_cache__', 'config.annotation', 'config.export', 'workspace.id'];
    // Diff the two Mirador states
    const difference = diff(initialState, currentState);
    // Remove known false positives from diff object
    const filtered = omit(difference, expectedDiffPaths);
    // Remove empty top-level objects created by prior call to omit
    const changes = omitBy(filtered, isEmpty);
    if (!isEmpty(changes)) {
      event.preventDefault();
      event.returnValue = 'If you navigate away from the workspace now, changes you have made will be lost. Are you sure you want to navigate away?'; // eslint-disable-line no-param-reassign
      return event.returnValue;
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
  projectResourcesUrl: PropTypes.string,
  saveInProgressSelector: PropTypes.string,
  state: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  updateStateSelector: PropTypes.string,
};

Viewer.defaultProps = {
  annototEndpointUrl: null,
  config: {},
  enabledPlugins: [],
  projectResourcesUrl: null,
  saveInProgressSelector: null,
  state: null,
  updateStateSelector: null,
};

export default Viewer;
