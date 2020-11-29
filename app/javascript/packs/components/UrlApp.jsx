// app/javascript/packs/components/UrlApp.jsx
import React from 'react'
import ReactDOM from 'react-dom'

import axios from "axios";

import ErrorMessage from "./ErrorMessage";
import UrlItems from "./UrlItems";
import UrlItem from "./UrlItem";
import UrlForm from "./UrlForm";
import Spinner from "./Spinner";

class UrlApp extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            urlItems: [],
            isLoading: true,
            errorMessage: null
        };
        this.getUrlItems = this.getUrlItems.bind(this);
        this.createUrlItem = this.createUrlItem.bind(this);
        this.handleErrors = this.handleErrors.bind(this)
        this.clearErrors = this.clearErrors.bind(this)
    }

    handleErrors(errorMessage) {
      this.setState({ errorMessage });
    }

    clearErrors() {
      this.setState({
        errorMessage: null
      });
    }

    componentDidMount() {
        this.getUrlItems();
      }

    getUrlItems() {
        axios
          .get("/api/v1/url_items")
          .then(response => {
            this.setState({ isLoading: true });
            const urlItems = response.data;
            this.setState({ urlItems });
            this.setState({ isLoading: false });
          })
          .catch(error => {
            this.setState({ isLoading: true });
            console.log(error);
          });
    }

    createUrlItem(urlItem) {
      const urlItems = [urlItem, ...this.state.urlItems];
      this.setState({ urlItems });
    }

    render() {
        return (
          <>
            {this.state.errorMessage && (
                    <ErrorMessage errorMessage={this.state.errorMessage} />
            )}
            {!this.state.isLoading && (
              <>
                <UrlForm 
                  createUrlItem={this.createUrlItem}
                  handleErrors={this.handleErrors}
                  clearErrors={this.clearErrors}
                />
                <UrlItems>
                  {this.state.urlItems.map(urlItem => (
                    <UrlItem
                      key={urlItem.short_url}
                      urlItem={urlItem}
                      getUrlItems={this.getUrlItems}
                    />
                  ))}
                </UrlItems>
              </>
            )}
            {this.state.isLoading && <Spinner />}
          </>
        );
    }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('url-app')
  app && ReactDOM.render(<UrlApp />, app)
})