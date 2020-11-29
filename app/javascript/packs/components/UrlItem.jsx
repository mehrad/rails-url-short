// app/javascript/packs/components/UrlItem.jsx
import React from 'react'
import PropTypes from 'prop-types'

import axios from "axios";
import setAxiosHeaders from "./AxiosHeaders";
class UrlItem extends React.Component {
  constructor(props) {
    super(props)
    this.state = {};

    this.handleDestroy = this.handleDestroy.bind(this);
    this.path = `/api/v1/url_items/${this.props.urlItem.short_url}`;
  }

  handleDestroy() {
    setAxiosHeaders();
    var $this = this
    const confirmation = confirm("Are you sure?");
    if (confirmation) {
      axios
        .delete(this.path)
        .then(response => {
          $this.props.getUrlItems();
        })
        .catch(error => {
          console.log(error);
        });
    }
  }

  render() {
    const { urlItem } = this.props
    return (
      <tr className='table-light'>
        <td>
          <input
            type="text"
            defaultValue={urlItem.url}
            disabled={true}
            className="form-control"
            id={`urlItem__url-${urlItem.short_url}`}
          />
        </td>
        <td>
          <input
            type="text"
            defaultValue={`${window.location.href}${urlItem.short_url}`}
            disabled={true}
            className="form-control"
            id={`urlItem__short_url-${urlItem.short_url}`}
          />
        </td>
        <td>
            <div>
                <label>
                    {urlItem.click_count}
                </label>
            </div>
        </td>
        <td className="text-right">
          <button
            className="btn btn-outline-danger"
            onClick={this.handleDestroy}
            >
              Delete
          </button>
        </td>
      </tr>
    )
  }
}

export default UrlItem

UrlItem.propTypes = {
  urlItem: PropTypes.object.isRequired,
  getUrlItems: PropTypes.func.isRequired
}