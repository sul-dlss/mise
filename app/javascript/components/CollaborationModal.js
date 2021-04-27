import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import Modal from '@material-ui/core/Modal';

function CollaborationModal({ url, csrfToken, currentUser }) {
  const [open, setOpen] = useState(false);
  const [email, setEmail] = useState();
  const [projectRoles, setProjectRoles] = useState({users: [], assignable_roles: []});

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

  const handleNewCollaborator = (e) => {
    e.preventDefault();

    fetch(url, {
      body: JSON.stringify({role: { email, role_name: 'viewer' }}),
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

  const CollaborationUser = ({email, role, id, url}) => {
    const handleRemoveCollaborator = () => {
      fetch(url, {
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        method: 'DELETE',
      }).then(response => response)
        .then(data => fetchProjectRole());
    }

    const handleChangeRole = (e) => {
      fetch(url, {
        body: JSON.stringify({role: {role_name: e.target.value }}),
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        method: 'PATCH',
      }).then(response => response)
        .then(data => fetchProjectRole());
      setEmail('');
    }

    const roleDropdown = <div className="dropdown">
      <button className="btn btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
        {role}
      </button>
      <ul className="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenu2">
        {
          projectRoles.assignableRoles.map((roleName) => (<li>
            <button className={[
                'dropdown-item', roleName == role
                  ? 'active'
                  : ''
              ].join(' ')} type="button" aria-current={roleName == role} onClick={handleChangeRole} value={roleName}>
              {roleName}
            </button>
          </li>))
        }
        <li>
          <hr className="dropdown-divider"/>
        </li>
        <li>
          <button onClick={handleRemoveCollaborator} className="dropdown-item" type="button">Remove collaborator</button>
        </li>
      </ul>
    </div>

    return <li className="px-0 list-group-item d-flex align-items-center">
      <div className="col">{email}</div>
      <div className="col-3">
        {currentUser == id || !projectRoles.assignableRoles.includes(role) ? <span className="btn btn-outline-secondary disabled">{role}</span> : roleDropdown}
        </div>
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
                {projectRoles.users.map((role) => (
                  <CollaborationUser email={role.email} key={role.id} role={role.role} id={role.id} url={role.url}
                  />
                ))}
              </ul>
            </div>
            <div className="modal-body border-top">
              Add new collaborators
              <form className="input-group mb-3" onSubmit={handleNewCollaborator}>
                <input value={email || ''} onChange={onEmailChange} type="text" className="form-control" placeholder="" aria-label="Recipient's username" aria-describedby="button-addon2" />
                <button className="btn btn-outline-secondary" type="submit" id="button-addon2">Add</button>
              </form>
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
