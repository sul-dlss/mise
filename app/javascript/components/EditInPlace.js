import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import isEmpty from 'lodash/isEmpty';

function EditInPlace(props) {
  const [value, setValue] = useState(props.value);
  const [savedValue, setSavedValue] = useState(value);
  const [mode, setMode] = useState('view');

  const onChange = e => { setValue(e.target.value); };
  const onSave = () => {
    if (isEmpty(value)) { setValue(savedValue); setMode('saved'); return }

    props.value != value && fetch(props.url || document.location, {
      method: 'PATCH',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': props.csrfToken,
      },
      body: JSON.stringify({ [props.field]: value }),
    });

    setSavedValue(value);

    setMode('saved');
  };

  let content;

  if (mode === 'edit') {
    content = (
      <>
        <form onSubmit={onSave} className="input-group w-50 edit-in-place-form">
          <input autoFocus value={value || ''} onChange={onChange} onBlur={onSave} className="edit-in-place form-control" />
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

  const Portal = ({ value, container, ...props }) => {
    const [innerHtmlEmptied, setInnerHtmlEmptied] = React.useState(false)

    React.useEffect(() => {
      if (!innerHtmlEmptied) {
        container.innerHTML = ''
        setInnerHtmlEmptied(true)
      }
    }, [innerHtmlEmptied])

    if (!innerHtmlEmptied) return null
    return ReactDOM.createPortal(value, container)
  }

  return (
    <span>
      { props.uuid && $('[data-field="' + props.field +'"][data-uuid="' + props.uuid + '"]').map((i, c) => <Portal value={savedValue} container={c} />) }
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
