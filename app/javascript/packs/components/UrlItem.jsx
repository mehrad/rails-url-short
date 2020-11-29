// app/javascript/packs/components/UrlItem.jsx
import React from 'react'
import PropTypes from 'prop-types'

class UrlItem extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  render() {
    const { urlItem } = this.props
    return (
      <tr className={`${this.state.complete ? 'table-light' : ''}`}>
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
            defaultValue={urlItem.short_url}
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
          <button className="btn btn-outline-danger">Delete</button>
        </td>
      </tr>
    )
  }
}

export default UrlItem

UrlItem.propTypes = {
  UrlItem: PropTypes.object.isRequired,
}