import React, { useState } from 'react';
import PropTypes from 'prop-types';
import Modal from '@material-ui/core/Modal';
import Snackbar from '@material-ui/core/Snackbar';

function ShareModal({ embedLink }) {
  const [open, setOpen] = useState(false);
  const [openSnack, setOpenSnack] = useState(false);
  const [openIframeCode, setOpenIframeCode] = useState(false);

  const iframeCode = `<iframe src="${embedLink}" width="100%" height="800" allowfullscreen frameborder="0"></iframe>`;

  const handleOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(embedLink).then(() => {
      setOpenSnack(true);
    });
  };

  const handleSnackClose = () => {
    setOpenSnack(false);
  };

  const handleCopyIframeCode = () => {
    navigator.clipboard.writeText(iframeCode).then(() => {
      setOpenSnack(true);
    });
  };

  const handleIframeCodeOpen = () => {
    setOpenIframeCode(true);
  };

  const handleIframeCodeClose = () => {
    setOpenIframeCode(false);
  };

  return (
    <>
      <button type="button" className="btn btn-outline-primary my-1" onClick={handleOpen}>Share</button>
      <Snackbar open={openSnack} autoHideDuration={6000} onClose={handleSnackClose}>
        <div className="alert alert-success">
          Embed code copied to clipboard
        </div>
      </Snackbar>

      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="simple-modal-title"
        aria-describedby="simple-modal-description"
      >
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <h5 className="modal-title">Share</h5>
              <button type="button" className="btn-close" onClick={handleClose} data-bs-dismiss="modal" aria-label="Close" />
            </div>
            <div className="modal-footer justify-content-start">
              <button type="button" className="btn btn-link" onClick={handleCopyLink}>Copy link</button>
              <button type="button" className="btn btn-link" onClick={openIframeCode ? handleIframeCodeClose : handleIframeCodeOpen}>Get embed code</button>
            </div>
            {
            openIframeCode && (
            <div className="modal-footer share-modal">
              <textarea value={iframeCode} rows={3} readOnly className="embed-text-area p-2 form-control" />
              <div className="pt-2 px-2">
                <button type="button" className="btn btn-link" onClick={handleIframeCodeClose}>Cancel</button>
                <button type="button" className="btn btn-primary" onClick={handleCopyIframeCode}>Copy</button>
              </div>
            </div>
            )
          }
          </div>
        </div>
      </Modal>
    </>
  );
}

ShareModal.propTypes = {
  embedLink: PropTypes.string.isRequired,
};

export default ShareModal;
