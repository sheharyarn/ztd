import React     from 'react'
import PropTypes from 'prop-types'


class TodoItem extends React.Component {
  constructor(props) {
    super(props);
  }


  render() {
    const {item} = this.props;
    const klass = item.done ? 'item is-done' : 'item';

    return (
      <div className={klass} data-item-id={item.id}>
        {item.title}
      </div>
    );
  }
}



// Prop Specification
TodoItem.propTypes = {
  item: PropTypes.shape({
    id:    PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    done:  PropTypes.bool.isRequired,
  }).isRequired,
};



// Export
export default TodoItem;

