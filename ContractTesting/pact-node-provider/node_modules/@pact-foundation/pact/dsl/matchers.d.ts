/** @module Matchers
 *
 * For specific matcher types (e.g. IpV6), the values generated are not random
 * but are fixed, to prevent contract invalidation after each run of the consumer test.
 */
export declare const ISO8601_DATE_FORMAT = "^([\\+-]?\\d{4}(?!\\d{2}\\b))((-?)((0[1-9]|1[0-2])(\\3([12]\\d|0[1-9]|3[01]))?|W([0-4]\\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\\d|[12]\\d{2}|3([0-5]\\d|6[1-6])))?)$";
export declare const ISO8601_DATETIME_FORMAT = "^\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d([+-][0-2]\\d:[0-5]\\d|Z)$";
export declare const ISO8601_DATETIME_WITH_MILLIS_FORMAT = "^\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}([+-][0-2]\\d:[0-5]\\d|Z)$";
export declare const ISO8601_TIME_FORMAT = "^(T\\d\\d:\\d\\d(:\\d\\d)?(\\.\\d+)?(([+-]\\d\\d:\\d\\d)|Z)?)?$";
export declare const RFC3339_TIMESTAMP_FORMAT = "^(Mon|Tue|Wed|Thu|Fri|Sat|Sun),\\s\\d{2}\\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\\s\\d{4}\\s\\d{2}:\\d{2}:\\d{2}\\s(\\+|-)\\d{4}$";
export declare const UUID_V4_FORMAT = "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$";
export declare const IPV4_FORMAT = "^(\\d{1,3}\\.)+\\d{1,3}$";
export declare const IPV6_FORMAT = "^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$";
export declare const HEX_FORMAT = "^[0-9a-fA-F]+$";
/**
 * Validates the given example against the regex.
 *
 * @param example Example to use in the matcher.
 * @param matcher Regular expression to check.
 */
export declare function validateExample(example: string, matcher: string): boolean;
/**
 * The term matcher. Also aliased to 'regex' for discoverability.
 * @param {Object} opts
 * @param {string} opts.generate - a value to represent the matched String
 * @param {string} opts.matcher - a Regex representing the value
 */
export declare function term(opts: {
    generate: string;
    matcher: string;
}): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * UUID v4 matcher.
 * @param {string} uuuid - a UUID to use as an example.
 */
export declare function uuid(id?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * IPv4 matcher.
 * @param {string} ip - an IPv4 address to use as an example. Defaults to `127.0.0.13`
 */
export declare function ipv4Address(ip?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * IPv6 matcher.
 * @param {string} ip - an IPv6 address to use as an example. Defaults to '::ffff:192.0.2.128'
 */
export declare function ipv6Address(ip?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * ISO8601 DateTime matcher.
 * @param {string} date - an ISO8601 Date and Time string
 *                        e.g. 2015-08-06T16:53:10+01:00 are valid
 */
export declare function iso8601DateTime(date?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * ISO8601 DateTime matcher with required millisecond precision
 * @param {string} date - an ISO8601 Date and Time string, e.g. 2015-08-06T16:53:10.123+01:00
 */
export declare function iso8601DateTimeWithMillis(date?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * ISO8601 Date matcher.
 * @param {string} date - a basic yyyy-MM-dd date string e.g. 2000-09-31
 */
export declare function iso8601Date(date?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 *  ISO8601 Time Matcher, matches a pattern of the format "'T'HH:mm:ss".
 * @param {string} date - a ISO8601 formatted time string e.g. T22:44:30.652Z
 */
export declare function iso8601Time(time?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * RFC3339 Timestamp matcher, a subset of ISO8609
 * @param {string} date - an RFC3339 Date and Time string, e.g. Mon, 31 Oct 2016 15:21:41 -0400
 */
export declare function rfc3339Timestamp(timestamp?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * Hexadecimal Matcher.
 * @param {string} hex - a hex value.
 */
export declare function hexadecimal(hex?: string): {
    data: {
        generate: string;
        matcher: {
            json_class: string;
            o: number;
            s: string;
        };
    };
    getValue: () => string;
    json_class: string;
};
/**
 * Decimal Matcher.
 * @param {float} float - a decimal value.
 */
export declare function decimal(float?: number): {
    contents: number;
    getValue: () => number;
    json_class: string;
};
/**
 * Integer Matcher.
 * @param {integer} int - an int value.
 */
export declare function integer(int?: number): {
    contents: number;
    getValue: () => number;
    json_class: string;
};
/**
 * Boolean Matcher.
 */
export declare function boolean(): {
    contents: boolean;
    getValue: () => boolean;
    json_class: string;
};
/**
 * The eachLike matcher
 * @param {any} content
 * @param {Object} opts
 * @param {Number} opts.min
 */
export declare function eachLike<T>(content: T, opts?: {
    min: number;
}): {
    contents: T;
    getValue: () => T[];
    json_class: string;
    min: number;
};
/**
 * The somethingLike matcher
 * @param {any} value - the value to be somethingLike
 */
export declare function somethingLike<T>(value: T): {
    contents: T;
    getValue: () => T;
    json_class: string;
};
export { somethingLike as like };
export { term as regex };
export interface MatcherResult {
    json_class: string;
    getValue(): any;
}
export declare function extractPayload(obj: any, stack?: any): any;
export declare function isMatcher(x: MatcherResult | any): x is MatcherResult;
