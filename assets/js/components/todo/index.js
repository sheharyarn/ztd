import React     from 'react'
import PropTypes from 'prop-types'
import _         from 'lodash'

import Socket    from '../../socket'
import TodoItem  from './todo-item'



class Todo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      items: this.props.items,
    };

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleOkEvent = this.handleOkEvent.bind(this);
    this.handleErrorEvent = this.handleErrorEvent.bind(this);
  }


  // Connect to channel on mount
  componentDidMount() {
    let channel = Socket.channel("todo_events", {});
    channel.on("event", this.handleOkEvent);

    channel
      .join()
      .receive("ok", this.handleOkEvent)
      .receive("error", this.handleErrorEvent)

    this.setState({channel});
  }


  // Handle OK Response on Channels
  handleOkEvent(response) {
    console.log("ok", response)
  }


  // Handle Error Response on Channels
  handleErrorEvent(response) {
    console.log("error", response)
  }


  // Find the item in the list and update state
  handleUpdate(item) {
    const {channel, items} = this.state;

    channel
      .push("update", {data: item})
      .receive("ok", this.handleOkEvent)
      .receive("error", this.handleErrorEvent)

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
