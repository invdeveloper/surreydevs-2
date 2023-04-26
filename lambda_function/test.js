
exports.handler = async function (event, context) {

  const hello_world = { "hello": "world" };
  console.log(JSON.stringify(hello_world));

  const response = {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'OPTIONS,POST',
      'Content-Type': 'text/html',
    },

    body: JSON.stringify(hello_world),
  };

  return response;
};
