import React from 'react';
import PropTypes from 'prop-types';
import Mirador from 'mirador/dist/es/src/index';
import miradorImageToolsPlugin from 'mirador-image-tools/es/plugins/miradorImageToolsPlugin';
import { importMiradorState } from 'mirador/dist/es/src/state/actions';
import { getExportableState } from 'mirador/dist/es/src/state/selectors';

/** */
class Viewer extends React.Component {
  /** */
  componentDidMount() {
    const {
      config, enabledPlugins, state, updateStateSelector,
    } = this.props;
    const instance = Mirador.viewer(
      config,
      [
        ...((enabledPlugins.includes('imageTools') && miradorImageToolsPlugin) || []),
      ],
    );
    if (state) instance.store.dispatch(importMiradorState(state));
    if (updateStateSelector) {
      instance.store.subscribe(() => {
        const currentState = instance.store.getState();
        const inputElement = document.querySelector(updateStateSelector);
        if (inputElement) {
          inputElement.value = JSON.stringify(getExportableState(currentState));
        }
      });
    }
  }

  /** */
  render() {
    const { config } = this.props;
    return <div id={config.id} />;
  }
}

Viewer.propTypes = {
  config: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  enabledPlugins: PropTypes.array, // eslint-disable-line react/forbid-prop-types,
  state: PropTypes.object, // eslint-disable-line react/forbid-prop-types
  updateStateSelector: PropTypes.string,
};

Viewer.defaultProps = {
  config: {},
  enabledPlugins: [],
  state: null,
  updateStateSelector: null,
};

export default Viewer;
