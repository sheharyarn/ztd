import React     from 'react'
import PropTypes from 'prop-types'
import _         from 'lodash'

import TodoItem  from './todo-item'



class Todo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: this.props.items,
    };

    this.handleUpdate = this.handleUpdate.bind(this);
  }


  // Find the item in the list and update state
  handleUpdate(item) {
    const {items} = this.state;
    const updated = _.map(items, i => {
      if (i.id === item.id) {
        return _.merge(i, item);
      } else {
        return i;
      }
    });

    this.setState({items: updated})
  }


  render() {
    const {items} = this.state;

    return (
      <div className='todo-app'>
        <todo-input />

        <div className='item-list'>
          { items.map(i =>
            <TodoItem key={i.id} item={i} onUpdate={this.handleUpdate} />
          )}
        </div>
      </div>
    );
  }
}



// Prop Specification
Todo.defaultProps = {
  items: [],
};

Todo.propTypes = {
  items: PropTypes.arrayOf(TodoItem.propTypes.item).isRequired,
};



// Export
export default Todo;
