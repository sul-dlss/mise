import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import Modal from '@material-ui/core/Modal';

function CollaborationModal({ url, csrfToken }) {
  const [open, setOpen] = useState(false);
  const [email, setEmail] = useState();
  const [projectRoles, setProjectRoles] = useState([]);

  const fetchProjectRole = ()=> {
    fetch(url, {
      headers: {
        Accept: 'application/json',
      },
      method: 'GET',
    }).then(response => response.json())
      .then(data => setProjectRoles(data));
  };

  useEffect(() => {fetchProjectRole()},[])

  const handleOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const onEmailChange = (e) => {
    setEmail(e.target.value);
  };

  const handleNewCollaborator = () => {
    fetch(url, {
      body: JSON.stringify({role: { uid: email, role_name: 'admin'}}),
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      method: 'POST',
    }).then(response => response)
      .then(data => fetchProjectRole());
    setEmail('');
  }

  const CollaborationUser = ({uid, role}) => {
    return <li className="px-0 list-group-item d-flex align-items-center">
      <div className="col">{uid}</div>
      <div className="col-3">
        <div className="dropdown">
          <button className="btn btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
            {role}
          </button>
          <ul className="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenu2">
            <li>
              <button className="dropdown-item active" aria-current="true" type="button">{role}</button>
            </li>
            <li>
              <button className="dropdown-item" type="button">other role</button>
            </li>
            <li>
              <hr className="dropdown-divider"/>
            </li>
            <li>
              <button className="dropdown-item" type="button">Remove collaborator</button>
            </li>
          </ul>
        </div></div>
    </li>
  }

  return (
    <>
      <button type="button" className="btn btn-outline-primary my-1" onClick={handleOpen}>Manage collaboration</button>

      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="simple-modal-title"
        aria-describedby="simple-modal-description"
      >
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <h5 className="modal-title">Project collaboration</h5>
              <button type="button" className="btn-close" onClick={handleClose} data-bs-dismiss="modal" aria-label="Close" />
            </div>
            <div className="modal-body">
              <ul className="list-group list-group-flush">
                {projectRoles.map((role) => (
                  <CollaborationUser uid={role.uid || role.email} key={role.uid} role={role.role}
                  />
                ))}
              </ul>
            </div>
            <div className="modal-body border-top">
              Add new collaborators
              <div className="input-group mb-3">
                <input value={email || ''} onChange={onEmailChange} type="text" className="form-control" placeholder="" aria-label="Recipient's username" aria-describedby="button-addon2" />
                <button onClick={handleNewCollaborator} className="btn btn-outline-secondary" type="button" id="button-addon2">Add</button>
              </div>
            </div>
            <div className="modal-footer justify-content-start">
              <button type="button" className="btn btn-link" onClick={handleClose}>Done</button>
            </div>
          </div>
        </div>
      </Modal>
    </>
  );
}

CollaborationModal.propTypes = {
  url: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default CollaborationModal;
