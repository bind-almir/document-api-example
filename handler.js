const response = (statusCode, body) => {
  return {
    statusCode,
    headers: { 
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(body)
  };
}

const get = async () => response(200, { message: 'Hi from get method!' });

const post = async (event) => {
  try {
    const { name } = JSON.parse(event.body);
    if(!name) throw {
      statusCode: 400,
      message: 'bad input'
    }
    return response(200, { message: `hello ${name}!` });
  } catch(err) {
    const { statusCode=500, message='server error' } = err;
    return response(statusCode, { message });
  }
}

module.exports = {
  get,
  post
}