import React     from 'react'
import PropTypes from 'prop-types'
import _         from 'lodash'


class TodoItem extends React.Component {
  constructor(props) {
    super(props);

    this.handleDone = this.handleDone.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
  }


  handleDone() {
    const {item} = this.props;
    const updated = _.merge(item, {done: !item.done});
    this.props.broadcast("update", item);
  }

  handleDelete() {
    const {item} = this.props;
    this.props.broadcast("delete", item);
  }



  render() {
    const {item} = this.props;
    const doneClass = item.done ? 'is-done' : '';

    return (
      <div className='item' data-item-id={item.id}>
        <input
          className='status'
          type='checkbox'
          value='Done'
          checked={item.done}
          onChange={this.handleDone}
        />

        <span className={`content ${doneClass}`}>
          {item.title}
        </span>

        <a className='delete' onClick={this.handleDelete}>×</a>
      </div>
    );
  }
}



// Prop Specification
TodoItem.propTypes = {
  broadcast: PropTypes.func.isRequired,
  item: PropTypes.shape({
    id:    PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    done:  PropTypes.bool.isRequired,
  }).isRequired,
};



// Export
export default TodoItem;

