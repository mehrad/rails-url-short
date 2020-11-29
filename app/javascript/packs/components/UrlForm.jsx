// app/javascript/packs/components/UrlForm.jsx
import React from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from "./AxiosHeaders";

class UrlForm extends React.Component {
  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.urlRef = React.createRef()
    this.shortUrlRef = React.createRef()
  }

  handleSubmit(e) {
    e.preventDefault()
    setAxiosHeaders();
    var $this = this
    axios
      .post('/api/v1/url_items', {
        url_item: {
          url: this.urlRef.current.value,
          short_url: this.shortUrlRef.current.value,
        },
      })
      .then(response => {
        const urlItem = response.data
        $this.props.createUrlItem(urlItem)
        $this.props.clearErrors();
      })
      .catch(error => {
        $this.props.handleErrors(error);
      })
    e.target.reset()
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit} className="my-3">
        <div className="form-row">
          <div className="form-group col-md-4">
            <input
            type="text"
            name="url"
            ref={this.urlRef}
            required
            className="form-control"
            id="url"
            placeholder="Write your url here..."
            />
          </div>
          <div className="form-group col-md-4">
            <input
              type="text"
              name="short_url"
              ref={this.shortUrlRef}
              className="form-control"
              id="short_url"
              placeholder="If you want write your short url here..."
              />
          </div>
          <div className="form-group col-md-4">
            <button className="btn btn-outline-success btn-block">
              Shorten!
            </button>
          </div>
        </div>
      </form>
    )
  }
}

export default UrlForm

UrlForm.propTypes = {
  createUrlItem: PropTypes.func.isRequired,
  handleErrors: PropTypes.func.isRequired,
  clearErrors: PropTypes.func.isRequired
}