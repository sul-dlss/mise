import React from 'react';
import PropTypes from 'prop-types';
import mapValues from 'lodash/mapValues';
import Mirador from 'mirador/dist/es/src/index';
import miradorImageToolsPlugin from 'mirador-image-tools/es/plugins/miradorImageToolsPlugin';
import miradorAnnotationsPlugins from 'mirador-annotations/es';
import { addResource, importMiradorState } from 'mirador/dist/es/src/state/actions';
import {
  getExportableState, getManifestTitle, getManifestProvider,
  getManifestoInstance, getCanvases
} from 'mirador/dist/es/src/state/selectors';
import AnnototAdapter from 'mirador-annotations/es/AnnototAdapter';


/** */
class Viewer extends React.Component {
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
          adapter: (canvasId) => new AnnototAdapter(canvasId, annototEndpointUrl)
        }
      };
    }

    const instance = Mirador.viewer(
      { ...config, ...annotationsConfig },
      [
        ...((enabledPlugins.includes('imageTools') && miradorImageToolsPlugin) || []),
        ...((enabledPlugins.includes('annotations') && miradorAnnotationsPlugins) || []),
      ],
    );
    if (state) instance.store.dispatch(importMiradorState({ ...state, config: instance.store.getState().config }));
    if (projectResourcesUrl) instance.store.dispatch(addResource(projectResourcesUrl))
    if (updateStateSelector) {
      instance.store.subscribe(() => {
        const currentState = instance.store.getState();
        const inputElement = document.querySelector(updateStateSelector);
        const __mise_cache__ = {
          manifests: mapValues(currentState.manifests, m => this.getManifestCache(currentState, m))
        };
        if (inputElement) {
          inputElement.value = JSON.stringify({ ...getExportableState(currentState), __mise_cache__ });
        }
      });
    }
  }

  getManifestCache(state, manifest) {
    if(!manifest.json) return;

    const manifestId = manifest.id;

    const manifesto = getManifestoInstance(state, { manifestId });
    const isCollection = (
      manifesto || { isCollection: () => false }
    ).isCollection();

    const size = isCollection
      ? manifesto.getTotalItems()
      : getCanvases(state, { manifestId }).length;

    return {
      label: getManifestTitle(state, { manifestId }),
      '@type': manifest.json.['@type'],
      itemcount: size,
      provider: getManifestProvider(state, { manifestId }),
    }
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
  enabledPlugins: PropTypes.array, // eslint-disable-line react/forbid-prop-types,
  state: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  projectResourcesUrl: PropTypes.string,
  updateStateSelector: PropTypes.string,
};

Viewer.defaultProps = {
  annototEndpointUrl: null,
  config: {},
  enabledPlugins: [],
  state: null,
  projectResourcesUrl: null,
  updateStateSelector: null,
};

export default Viewer;
