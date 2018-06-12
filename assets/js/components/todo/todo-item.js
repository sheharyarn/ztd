import React     from 'react'
import PropTypes from 'prop-types'
import _         from 'lodash'


class TodoItem extends React.Component {
  constructor(props) {
    super(props);

    this.toggleDone = this.toggleDone.bind(this);
  }


  toggleDone() {
    const {item} = this.props;
    const updated = _.merge(item, {done: !item.done});
    this.props.onUpdate(updated);
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
          onChange={this.toggleDone}
        />

        <span className={`content ${doneClass}`}>
          {item.title}
        </span>
      </div>
    );
  }
}



// Prop Specification
TodoItem.propTypes = {
  onUpdate: PropTypes.func.isRequired,
  item: PropTypes.shape({
    id:    PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    done:  PropTypes.bool.isRequired,
  }).isRequired,
};



// Export
export default TodoItem;

