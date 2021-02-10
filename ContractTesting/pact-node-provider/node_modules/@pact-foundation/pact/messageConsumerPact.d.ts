/**
 * @module Message
 */
import { Metadata, Message, MessageProvider, MessageConsumer } from "./dsl/message";
import { MessageConsumerOptions } from "./dsl/options";
/**
 * A Message Consumer is analagous to a Provider in the HTTP Interaction model.
 * It is the receiver of an interaction, and needs to be able to handle whatever
 * request was provided.
 */
export declare class MessageConsumerPact {
    private config;
    private state;
    constructor(config: MessageConsumerOptions);
    /**
     * Gives a state the provider should be in for this Message.
     *
     * @param {string} providerState - The state of the provider.
     * @returns {Message} MessageConsumer
     */
    given(providerState: string): this;
    /**
     * A free style description of the Message.
     *
     * @param {string} description - A description of the Message to be received
     * @returns {Message} MessageConsumer
     */
    expectsToReceive(description: string): this;
    /**
     * The content to be received by the message consumer.
     *
     * May be a JSON document or JSON primitive.
     *
     * @param {string} content - A description of the Message to be received
     * @returns {Message} MessageConsumer
     */
    withContent(content: any): this;
    /**
     * Message metadata
     *
     * @param {string} metadata -
     * @returns {Message} MessageConsumer
     */
    withMetadata(metadata: Metadata): this;
    /**
     * Returns the Message object created.
     *
     * @returns {Message}
     */
    json(): Message;
    /**
     * Creates a new Pact _message_ interaction to build a testable interaction.
     *
     * @param handler A message handler, that must be able to consume the given Message
     * @returns {Promise}
     */
    verify(handler: MessageConsumer): Promise<any>;
    /**
     * Validates the current state of the Message.
     *
     * @returns {Promise}
     */
    validate(): Promise<any>;
    private getServiceFactory;
}
export declare function synchronousBodyHandler(handler: (body: any) => any): MessageProvider;
export declare function asynchronousBodyHandler(handler: (body: any) => Promise<any>): MessageProvider;
