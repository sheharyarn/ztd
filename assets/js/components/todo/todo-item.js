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
    const klass = item.done ? 'item is-done' : 'item';

    return (
      <div className={klass} data-item-id={item.id} onClick={this.toggleDone}>
        {item.title}
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

