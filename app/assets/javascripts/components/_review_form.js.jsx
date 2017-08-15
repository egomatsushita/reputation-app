var ReviewForm = React.createClass({
  handleClick() {
    var i = [999];
    var author_id = 2;
    var receiver_id = 1;
    var content = this.refs.review.value;
    var category_id = this.refs.category.value;
    var reviewObject = {
                        id: i.last,
                        author_id: author_id,
                        receiver_id: receiver_id,
                        content: content,
                        category_id: parseInt(category_id, 10)
                      }
    $.ajax({
      url: '/reviews',
      type: 'POST',
      data: {
        review: reviewObject
        },
        success: (response) => {
          console.log('it worked!', response);
          console.log(this.props.showAllReviews)
          this.props.addReview(reviewObject)
          i.push(i.last + 1)
      }
    });
    this.props.close
  },

  onClick: function(e){
    this.handleClick();
    this.props.close(e);
  },

  render() {
    return (
      <div>
      <p>Reviewing NAME as a... </p>
        <select ref='category'>
          <option value="1">Buyer</option>
          <option value="2">Seller</option>
          <option value="3">Driver</option>
          <option value="4">Labourer</option>
          <option value="5">Service</option>
          <option value="6">Other</option>
        </select>
        </br>
        <input ref='review' placeholder='Enter a review' />
        </br>
        <p>IMAGE UPLOAD HERE</p>

        <button onClick={this.onClick}>Submit</button>
      </div>
    )
  }
});