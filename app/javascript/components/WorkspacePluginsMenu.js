import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

function WorkspacePluginsMenu(props) {

  const PluginsPortal = () => {
    return ReactDOM.createPortal('wooo', document.getElementById('WorkspacePluginsMenu'));
  }

  return <PluginsPortal />
}

WorkspacePluginsMenu.propTypes = {
};

export default WorkspacePluginsMenu;
