import React, { useState } from "react"

function Favorite(props) {
  const [favorite, setFavorite] = useState(props.favorite);

  const changeFavorite = e => {
    fetch(props.updateUrl, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': props.csrfToken,
      },
      body: JSON.stringify({ 'favorite': !favorite })
    }).then(response => response.json())
    .then(data => setFavorite(data.favorite))
  };

  let classes = 'bi-star'
  if (favorite) {
    classes='bi-star-fill'
  }
  return (<span className={classes} onClick={changeFavorite}></span>)
}

export default Favorite
