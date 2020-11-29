// app/javascript/packs/components/UrlApp.jsx
import React from 'react'
import ReactDOM from 'react-dom'

import axios from "axios";

import UrlItems from "./UrlItems";
import UrlItem from "./UrlItem";

class UrlApp extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            urlItems: []
        };
        this.getUrlItems = this.getUrlItems.bind(this);
    }

    componentDidMount() {
        this.getUrlItems();
      }

    getUrlItems() {
        axios
          .get("/api/v1/url_items")
          .then(response => {
            const urlItems = response.data;
            this.setState({ urlItems });
          })
          .catch(error => {
            console.log(error);
          });
    }

    render() {
        return (
            <UrlItems>
              {this.state.urlItems.map(urlItem => (
                <UrlItem key={urlItem.short_url} urlItem={urlItem} />
              ))}
            </UrlItems>
        );
    }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('url-app')
  app && ReactDOM.render(<UrlApp />, app)
})