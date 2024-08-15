function errorMiddleware(error, req, res, next) {
    res.status(error.status || 500);
    res.send({
        error: {
            status: error.status || 500,
            message: error.message

        }
    });
}
module.exports = errorMiddleware;