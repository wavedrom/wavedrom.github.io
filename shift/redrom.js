module.exports = function (root) {
    var res, obj, arr, indent;

    obj = function (tree) {
        var ret, child;
        ret = '<span class="redrom-syn">{</span>\n';
        indent += '  ';
        Object.keys(tree).forEach(function (key) {
            ret += '<span class="redrom-key">' + indent + key + '</span>';
            ret += '<span class="redrom-syn">: </span>';
            ret += '<span class="redrom-val">';
            child = Object.prototype.toString.call(tree[key]);
            if (child === '[object Object]') {
                ret += obj(tree[key]);
            } else if (child === '[object Array]') {
                ret += arr(tree[key]);
            } else {
                ret += tree[key] + '</span>\n';
            }
        });
        indent = indent.slice(0, -2);
        ret += '<span class="redrom-syn">' + indent + '}</span>\n';
        return ret;
    };

    arr = function (tree) {
        var ret, child;
        if (tree.length === 0) return '<span class="redrom-syn">[]</span>\n';
        ret = '<span class="redrom-syn">[</span>\n';
        indent += '  ';
        ret += indent;
        tree.forEach(function (e, i) {
            child = Object.prototype.toString.call(e);
            if (child === '[object Object]') {
                ret += obj(e);
            } else if (child === '[object Array]') {
                ret += arr(e);
            } else {
                ret += e + '</span>\n';
            }
            if (i < tree.length - 1) {
                ret += indent;
            }
        });
        indent = indent.slice(0, -2);
        ret += '<span class="redrom-syn">' + indent + ']</span>\n';
        return ret;
    };

    indent = '';
    res = obj(root);
    return res;
};
