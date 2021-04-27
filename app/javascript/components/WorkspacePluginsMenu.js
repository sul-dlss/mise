import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

function WorkspacePluginsMenu(props) {

  const PluginsPortal = ({children}) => {
    return ReactDOM.createPortal(children, document.getElementById('WorkspacePluginsMenu'));
  }

  const handleChangePlugin = (e) => {
    e.stopPropagation()
    console.log(e.target.value);
  }

  return <PluginsPortal>
  <div className="dropdown">
   <button className="btn btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
   Manage plugins
   </button>
   <ul className="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenu2">
     <li>
       <label className="dropdown-item d-flex flex-row">
         <input className="form-check-input me-3" type="checkbox" value="annotation-creation" onChange={handleChangePlugin} />
         <div className="flex-column">
           <span className="fw-bold">Annotation creation</span>
           <p>Adds annotation creation tools to the Annotations section of the window sidebar</p>
         </div>
       </label>
     </li>
     <li>
       <label className="dropdown-item d-flex flex-row">
         <input className="form-check-input me-3" type="checkbox" value="download-links" onChange={handleChangePlugin} />
         <div className="flex-column">
           <span className="fw-bold">Download links</span>
           <p>Adds manifest-provided download links to the window options</p>
         </div>
       </label>
     </li>
     <li>
       <label className="dropdown-item d-flex flex-row">
         <input className="form-check-input me-3" type="checkbox" value="image-tools" onChange={handleChangePlugin} />
         <div className="flex-column">
           <span className="fw-bold">Image tools</span>
           <p>Adds image manipulation tools to the window options</p>
         </div>
       </label>
     </li>
     <li>
       <label className="dropdown-item d-flex flex-row" >
        <input className="form-check-input me-3" type="checkbox" value="share" onChange={handleChangePlugin} />
        <div className="flex-column">
          <span className="fw-bold">Share</span>
          <p>Adds share link, copyable embed code, and a drag-and-drop icon to the window options</p>
        </div>
       </label>
     </li>
   </ul>
 </div>
  </PluginsPortal>
}

WorkspacePluginsMenu.propTypes = {
};

export default WorkspacePluginsMenu;
