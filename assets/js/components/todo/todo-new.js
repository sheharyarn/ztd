import React     from 'react'
import PropTypes from 'prop-types'


class TodoNew extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      text: '',
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleKeyPress = this.handleKeyPress.bind(this);
  }


  handleChange(e) {
    this.setState({text: e.target.value});
  }


  handleKeyPress(e) {
    if (e.key === 'Enter') {
      const {text} = this.state;
      this.props.broadcast("insert", {title: text});
      this.setState({text: ''});
    }
  }


  render() {
    const {text} = this.state;

    return (
      <div className='new-item'>
        <input
          type='text'
          value={text}
          placeholder='Enter a new Item'
          onChange={this.handleChange}
          onKeyPress={this.handleKeyPress}
        />
      </div>
    );
  }
}



// Prop Specification
TodoNew.propTypes = {
  broadcast: PropTypes.func.isRequired,
};



// Export
export default TodoNew;
