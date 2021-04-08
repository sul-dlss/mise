import React, { useState } from 'react';
import PropTypes from 'prop-types';

function EditInPlace(props) {
  const [value, setValue] = useState(props.value);
  const [mode, setMode] = useState('view');

  const onChange = e => { setValue(e.target.value); };
  const onSave = () => {
    props.value != value && fetch(props.url || document.location, {
      method: 'PATCH',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': props.csrfToken,
      },
      body: JSON.stringify({ [props.field]: value }),
    });

    setMode('view');
  };

  let content;

  if (mode === 'edit') {
    content = (
      <>
        <form onSubmit={onSave}>
          <input autoFocus value={value || ''} onChange={onChange} onBlur={onSave} className="form-input" />
          <input className="btn btn-primary" type="submit" value="save" />
        </form>
      </>
    );
  } else {
    content = (
      <>
        <span onClick={() => setMode('edit')}>{value || <i>{props.placeholder}</i>}</span>
        <button type="button" className="btn btn-link" onClick={() => setMode('edit')}>
          <i className="bi-pencil-square" aria-hidden="true" />
          <span className="visually-hidden">edit</span>
        </button>
      </>
    );
  }

  return (
    <span>
      {content}
    </span>
  );
}

EditInPlace.propTypes = {
  field: PropTypes.string.isRequired,
  placeholder: PropTypes.string,
  url: PropTypes.string,
  value: PropTypes.string,
};

EditInPlace.defaultProps = {
  placeholder: '',
  value: '',
  url: undefined,
};

export default EditInPlace;
