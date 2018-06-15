import React     from 'react'
import PropTypes from 'prop-types'
import _         from 'lodash'

import Socket    from '../../socket'
import TodoNew   from './todo-new'
import TodoItem  from './todo-item'



class Todo extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      status: 'Inactive',
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
      .receive("ok", m => this.setState({status: 'Connected!'}))
      .receive("error", m => this.setState({status: 'Connection Failed!'}))

    this.setState({
      channel: channel,
      status: 'Connecting...',
    });
  }


  // Handle OK Response on Channels
  handleOkEvent(response) {
    const {items} = this.state;
    const item = response.data;
    let updated = items;

    switch (response.type) {
      // Insert new Item
      case "insert":
        updated = _.concat(items, item);
        console.log("Inserted:", item.id);
        break;


      // Find the item in the list
      case "update":
        updated = _.map(items, i => {
          if (i.id === item.id) {
            return _.merge(i, item);
          } else {
            return i;
          }
        });
        console.log("Updated: ", item.id);
        break;


      // Delete the item from list
      case "delete":
        updated = _.reject(items, i => {
          return i.id === item.id;
        });
        console.log("Deleted: ", item.id);
        break;


      // Unexpected Message
      default:
        console.log("Channel: ", response);
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
    const {items, status} = this.state;
    const {mode} = this.props;

    return (
      <div className='todo-app'>
        <div className='status'>
          <span><b>App Mode:</b> {mode}</span>
          <span><b>Status:</b> {status}</span>
        </div>
        <TodoNew
          broadcast={this.broadcast}
        />

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
  mode:  PropTypes.string.isRequired,
  items: PropTypes.arrayOf(TodoItem.propTypes.item).isRequired,
};



// Export
export default Todo;
