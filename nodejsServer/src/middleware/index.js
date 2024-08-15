const loggerMiddleware = require('./logger_middleware');
const errorMiddleware = require('./error_middleware');
const verifyMiddleware = require('./verify_record_middleware')

module.exports = {loggerMiddleware,errorMiddleware,verifyMiddleware}
