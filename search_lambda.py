import logging
import os

logger = logging.getLogger()

ACTIONS = {
    'plus': lambda x, y: x + y,
    'minus': lambda x, y: x - y,
    'times': lambda x, y: x * y,
    'divided-by': lambda x, y: x / y}

def lambda_handler(event, context):
    logger.setLevel(os.environ.get('LOG_LEVEL', logging.INFO))
    logger.debug('Event: %s', event)

    action = event.get('action')
    func = ACTIONS.get(action)
    x = event.get('x')
    y = event.get('y')
    result = None
    try:
        if func is not None and x is not None and y is not None:
            result = func(x, y)
            logger.info("%s %s %s is %s", x, action, y, result)
        else:
            logger.error("I can't calculate %s %s %s.", x, action, y)
    except ZeroDivisionError:
        logger.warning("I can't divide %s by 0!", x)

    response = {'result': result}
    return response