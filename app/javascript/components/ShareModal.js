import React, { useState } from "react";
import Modal from '@material-ui/core/Modal';
import Snackbar from '@material-ui/core/Snackbar';

function ShareModal(props) {
  const [open, setOpen] = useState(false);
  const [openSnack, setOpenSnack] = useState(false);
  const [openIframeCode, setOpenIframeCode] = useState(false);

  const iframeCode = `<iframe src="${props.embedLink}" width="100%" height="800" allowfullscreen frameborder="0"></iframe>`;

  const handleOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(props.embedLink).then(() => {
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

  return <React.Fragment>
    <button className="btn btn-outline-primary my-1" onClick={handleOpen}>Share</button>
    <Snackbar open={openSnack} autoHideDuration={6000} onClose={handleSnackClose}>
      <div className="alert alert-success">
        Copied to clipboard
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
            <button type="button" className="btn-close" onClick={handleClose} data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div className="modal-footer justify-content-start">
            <button type="button" className="btn btn-link" onClick={handleCopyLink}>Copy link</button>
            <button type="button" className="btn btn-link" onClick={openIframeCode ? handleIframeCodeClose : handleIframeCodeOpen}>Get embed code</button>
          </div>
          {
            openIframeCode && <div className="modal-footer justify-content-start row">
              <textarea value={iframeCode} readOnly className="col-7" />
              <div className="col-4">
                <button type="button" className="btn btn-link" onClick={handleIframeCodeClose}>Cancel</button>
                <button type="button" className="btn btn-primary" onClick={handleCopyIframeCode}>Copy</button>
              </div>
            </div>
          }
        </div>
      </div>
    </Modal>
  </React.Fragment>
}

export default ShareModal
