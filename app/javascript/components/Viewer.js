import React from 'react';
import PropTypes from 'prop-types'
import Mirador from 'mirador/dist/es/src/index.js';
import miradorImageToolsPlugin from 'mirador-image-tools/es/plugins/miradorImageToolsPlugin.js';
import { importMiradorState } from 'mirador/dist/es/src/state/actions';
class Viewer extends React.Component {
  componentDidMount() {
    const { config, enabledPlugins, state, updateStateSelector } = this.props;
    const instance = Mirador.viewer(
      config,
      [
        ...((enabledPlugins.includes('imageTools') && miradorImageToolsPlugin) || []),
      ],
    )
    if (state) instance.store.dispatch(importMiradorState(state));
    if (updateStateSelector) {
      instance.store.subscribe(() => {
        var state = instance.store.getState();
        document.querySelector(updateStateSelector).value = JSON.stringify(state);
      });
    }
  }

  render () {
    const { config } = this.props;
    return <div id={config.id} />;
  }
}

Viewer.propTypes = {
  config: PropTypes.object,
  enabledPlugins: PropTypes.array,
};

Viewer.defaultProps = {
  enabledPlugins: [],
  state: null,
}


export default Viewer;
