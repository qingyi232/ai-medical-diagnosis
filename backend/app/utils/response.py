from flask import jsonify


def success(data=None, message='操作成功', code=200):
    return jsonify({
        'code': code,
        'message': message,
        'data': data
    }), code


def error(message='操作失败', code=400, data=None):
    return jsonify({
        'code': code,
        'message': message,
        'data': data
    }), code


def paginate_response(query, page, per_page):
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    items = [item.to_dict() for item in pagination.items]
    return {
        'items': items,
        'total': pagination.total,
        'page': pagination.page,
        'per_page': pagination.per_page,
        'pages': pagination.pages,
    }
