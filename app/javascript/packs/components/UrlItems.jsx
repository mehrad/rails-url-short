// app/javascript/packs/components/Urltems.jsx
import React from 'react'

class Urltems extends React.Component {
  constructor(props) {
    super(props)
  }
  render() {
    return (
      <>
        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th scope="col">Original Url</th>
                <th scope="col">Shortened Url</th>
                <th scope="col">Click Count</th>
                <th scope="col" className="text-right">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody>{this.props.children}</tbody>
          </table>
        </div>
      </>
    )
  }
}
export default Urltems