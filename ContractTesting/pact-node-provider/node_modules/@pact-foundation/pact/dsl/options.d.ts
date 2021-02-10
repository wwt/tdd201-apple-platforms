/**
 * Pact Options module.
 * @module PactOptions
 */
import { PactfileWriteMode } from "./mockService";
import { MessageProviders, StateHandlers } from "../pact";
export declare type LogLevel = "trace" | "debug" | "info" | "warn" | "error" | "fatal";
export interface PactOptions {
    consumer: string;
    provider: string;
    port?: number;
    host?: string;
    ssl?: boolean;
    sslcert?: string;
    sslkey?: string;
    dir?: string;
    log?: string;
    logLevel?: LogLevel;
    spec?: number;
    cors?: boolean;
    pactfileWriteMode?: PactfileWriteMode;
}
export interface MandatoryPactOptions {
    port: number;
    host: string;
    ssl: boolean;
}
export declare type PactOptionsComplete = PactOptions & MandatoryPactOptions;
export interface MessageProviderOptions {
    consumer: string;
    provider: string;
    providerVersion?: string;
    pactUrls?: string[];
    log?: string;
    logLevel?: LogLevel;
    messageProviders: MessageProviders;
    stateHandlers?: StateHandlers;
    pactfileWriteMode?: PactfileWriteMode;
    providerStatesSetupUrl?: string;
    pactBrokerUsername?: string;
    pactBrokerPassword?: string;
    customProviderHeaders?: string[];
    publishVerificationResult?: boolean;
    pactBrokerUrl?: string;
    tags?: string[];
    timeout?: number;
}
export interface MessageConsumerOptions {
    consumer: string;
    dir?: string;
    provider: string;
    log?: string;
    logLevel?: LogLevel;
    spec?: number;
    pactfileWriteMode?: PactfileWriteMode;
}
