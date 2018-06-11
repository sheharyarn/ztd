import React     from 'react'
import PropTypes from 'prop-types'

import TodoItem  from './todo-item'



class Todo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: this.props.items,
    };
  }


  render() {
    const {items} = this.state;

    return (
      <div className='todo-app'>
        <todo-input />

        <div className='item-list'>
          { items.map(i =>
            <TodoItem key={i.id} item={i} />
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
