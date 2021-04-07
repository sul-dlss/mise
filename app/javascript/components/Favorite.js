import React, { useState } from 'react';
import PropTypes from 'prop-types';

function Favorite({ csrfToken, favorite, updateUrl }) {
  const [isFavorite, setFavorite] = useState(favorite);

  const changeFavorite = () => {
    setFavorite(!isFavorite);

    fetch(updateUrl, {
      body: JSON.stringify({ favorite: !isFavorite }),
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      method: 'PATCH',
    }).then(response => response.json())
      .then(data => setFavorite(data.favorite));
  };

  let classes = 'bi-star btn btn-link';
  if (isFavorite) {
    classes = 'bi-star-fill btn btn-link';
  }
  return (
    <button type="button" className={classes} onClick={changeFavorite} aria-label="Favorite" />
  );
}

Favorite.propTypes = {
  csrfToken: PropTypes.string.isRequired,
  favorite: PropTypes.bool.isRequired,
  updateUrl: PropTypes.string.isRequired,
};

export default Favorite;
