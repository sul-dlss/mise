import React, { useState, useEffect } from "react"

function EditInPlace(props) {
  const [value, setValue] = useState(props.value);
  const [mode, setMode] = useState('view');

  const onChange = e => { setValue(e.target.value) };
  const onSave = e => {
    props.value != value && fetch(document.location, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': props.csrfToken,
      },
      body: JSON.stringify({ [props.field]: value })
    });

    setMode('view')
  };

  let content;

  if (mode === 'edit') {
    content = <React.Fragment>
      <input autoFocus value={value} onChange={onChange} onBlur={onSave} className="form-input" />
      <button onClick={onSave}>save</button>
    </React.Fragment>;
  } else {
    content = <React.Fragment>
      <span onClick={() => setMode('edit')}>{value}</span>
      <button onClick={() => setMode('edit')}>edit</button>
    </React.Fragment>;
  }

  return (
    <span>
      {content}
    </span>
  );
}

export default EditInPlace
