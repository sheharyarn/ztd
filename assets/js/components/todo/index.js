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

    this.broadcast = this.broadcast.bind(this);
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
    const {items} = this.state;
    const item = response.data;
    let updated = items;

    switch (response.type) {
      // Find the item in the list
      case "update":
        updated = _.map(items, i => {
          if (i.id === item.id) {
            return _.merge(i, item);
          } else {
            return i;
          }
        });
        console.log("Updated:", item.id);
        break;


      case "insert":
        break;


      // Delete the item from list
      case "delete":
        updated = _.reject(items, i => {
          return i.id === item.id;
        });
        console.log("Deleted:", item.id);
        break;


      // Unexpected Message
      default:
        console.log("Channel:", response);
        updated = items;
        break;
    }

    // Finally update state
    this.setState({items: updated})
  }


  // Handle Error Response on Channels
  handleErrorEvent(response) {
    console.error("Error!", response);
  }


  // Broadcast item events on channel
  broadcast(type, item) {
    const {channel} = this.state;

    channel
      .push(type, {data: item})
      .receive("ok", this.handleOkEvent)
      .receive("error", this.handleErrorEvent)
  }


  render() {
    const {items} = this.state;

    return (
      <div className='todo-app'>
        <todo-input />

        <div className='item-list'>
          { items.map(i =>
            <TodoItem
              key={i.id}
              item={i}
              broadcast={this.broadcast}
            />
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
