import React from 'react';
import PropTypes from 'prop-types'
import Mirador from 'mirador/dist/es/src/index.js';
import miradorImageToolsPlugin from 'mirador-image-tools/es/plugins/miradorImageToolsPlugin.js';
class Viewer extends React.Component {
  componentDidMount() {
    const { config, enabledPlugins } = this.props;
    Mirador.viewer(
      config,
      [
        ...((enabledPlugins.includes('imageTools') && miradorImageToolsPlugin) || []),
      ],
    )
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
}


export default Viewer;
