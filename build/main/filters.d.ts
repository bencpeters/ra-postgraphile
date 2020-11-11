import type { IntrospectionNamedTypeRef, IntrospectionType } from 'graphql';
export declare const mapFilterType: (type: IntrospectionNamedTypeRef, value: any, key: string) => {
    [x: string]: {
        equalTo: any;
    };
    or?: undefined;
} | {
    or: ({
        [x: string]: {
            equalTo: any;
        };
    } | {
        [x: string]: {
            like: string;
        };
    })[];
} | {
    [x: string]: {
        in: any[];
    };
    or?: undefined;
};
export declare const createFilter: (fields: any, type: IntrospectionType) => {
    and: object[];
} | undefined;
