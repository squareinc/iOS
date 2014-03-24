/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import "DeferredBinding.h" // For compatibility, to be removed

@class ORObjectIdentifier;
@class ORModelObject;

/**
 * The panel XML document structure allows definition of forward references to yet undefined objects.
 * An ORDeferredBinding stores a relationship between 2 objects in the model.
 * It conveys the semantic of an enclosing object, on which the relationship will be set.
 *
 * After the whole model has been parsed and all objects have been instantiated, the parsing process
 * iterates on all the bindings and asks them to establish the relationships (via the bind method).
 *
 * This is an abstract class. Specific subclasses are used to implement the appropriate binding
 * depending on the objects that they link.
 */
@interface ORDeferredBinding : DeferredBinding /* for compatibility with legacy code, should be NSObject */

/**
 * Initializes a binding between two objects of the model.
 * Both parameters must be non nil.
 *
 * @param anIdentifier identifier of the (not yet existing) object to be linked to the enclosing object
 * @param anEnclosingObject object in the model on which to later set the relationship
 *
 * @return an ORDeferredBinding instance initialized with the provided data
 */
- (instancetype)initWithBoundComponentId:(ORObjectIdentifier *)anIdentifier enclosingObject:(ORModelObject *)anEnclosingObject;

/**
 * Make the appropriate link between the model objects, as represented by this binding.
 *
 * This is an abstract method. Subclasses are required to provide an appropriate implementation.
 */
- (void)bind;

/**
 * Identifier of the object that will be linked to the enclosing object.
 */
@property (nonatomic, strong, readonly) ORObjectIdentifier *boundComponentId;

/**
 * Object on which the relationship should be set.
 */
@property (nonatomic, weak, readonly) ORModelObject *enclosingObject;

@end
