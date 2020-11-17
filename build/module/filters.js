var __spreadArrays = (this && this.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};
export var mapFilterType = function (type, value, key) {
    var _a, _b, _c, _d, _e;
    var normalizedName = type.name.toLowerCase();
    switch (normalizedName) {
        case 'boolean':
            return _a = {},
                _a[key] = {
                    equalTo: value,
                },
                _a;
        case 'string':
            return {
                or: [
                    (_b = {},
                        _b[key] = {
                            equalTo: value,
                        },
                        _b),
                    (_c = {},
                        _c[key] = {
                            like: "%" + value + "%",
                        },
                        _c),
                ],
            };
        case 'uuid':
        case 'bigint':
        case 'int':
            return Array.isArray(value)
                ? (_d = {},
                    _d[key] = {
                        in: value,
                    },
                    _d) : (_e = {},
                _e[key] = {
                    equalTo: value,
                },
                _e);
        default:
            throw new Error("Filter for type " + type.name + " not implemented.");
    }
};
export var createFilter = function (fields, type) {
    var empty = [];
    var filters = Object.keys(fields).reduce(function (next, key) {
        var maybeType = type.fields.find(function (f) { return f.name === key; });
        if (maybeType) {
            var thisType = maybeType.type.ofType || maybeType.type;
            return __spreadArrays(next, [mapFilterType(thisType, fields[key], key)]);
        }
        return next;
    }, empty);
    if (filters === empty) {
        return undefined;
    }
    return { and: filters };
};