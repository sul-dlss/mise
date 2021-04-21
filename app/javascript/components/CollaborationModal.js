import React, { useState } from 'react';
import PropTypes from 'prop-types';
import Modal from '@material-ui/core/Modal';

function CollaborationModal({ adminUsers, embedLink }) {
  const [open, setOpen] = useState(false);

  const handleOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const CollaborationUser = ({uid, role}) => {
    return <div className="row">
      <div className="col">{uid}</div>
      <div className="col-3">
        <div class="dropdown">
          <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
            {role}
          </button>
          <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenu2">
            <li>
              <button class="dropdown-item active" aria-current="true" type="button">{role}</button>
            </li>
            <li>
              <button class="dropdown-item" type="button">other role</button>
            </li>
            <li>
              <hr className="dropdown-divider"/>
            </li>
            <li>
              <button class="dropdown-item" type="button">Remove collaborator</button>
            </li>
          </ul>
        </div></div>
    </div>
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

            {adminUsers.map((user) => (
              <CollaborationUser uid={user} key={user} role="admin"
              />
            ))}
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
  adminUsers: PropTypes.arrayOf(PropTypes.string),
  embedLink: PropTypes.string.isRequired,
};

export default CollaborationModal;
