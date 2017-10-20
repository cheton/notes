# Authorization

* [React](https://github.com/cheton/notes/blob/master/Authorization.md#React)
* [jQuery Plugin](https://github.com/cheton/notes/blob/master/Authorization.md#jquery-plugin)

## Store

```js
{
    user: {
        name: 'John Doe',
        role: 'administrator', // administrator|user|guest
        ownedPermissions: ['read', 'write', 'exec'] // Not defined yet
   }
}
```

## Guideline

The authorization logic and state should be centrally controlled from the container, not within the component.

```js
{user.role === 'administrator' && (
    <AdministratorView>
        <Toolbar>
        <Groups />
        <Devices />
    </AdministratorView>
)}

{user.role === 'user' && (
    <UserView>
        <Groups />
        <Devices />
    </UserView>
)}
```

## React

### withAuthorization (HOC)

```js
import React, { PureComponent } from 'react';
import intersect from 'lodash.intersect';
import ensureArray from 'lib/ensure-array';

const withAuthorization = (allowedRoles = [], allowedPermissions = []) => {
    allowedRoles = ensureArray(allowedRoles);
    allowedPermissions = ensureArray(allowedPermissions);
    
    return (WrappedComponent) => class WithAuthorization extends PureComponent {
        state = this.getInitialState();

        getInitialState() {
            // The state can be loaded from your Redux store or somewhere else.
            return {
                user: store.get('user')
            };
        }
        render() {
            const {
                user: {
                    role,
                    ownedPermissions                    
                }
            } = this.state;
            
            if ((allowedRoles.length > 0) && !allowedRoles.includes(role)) {
                return null;
            }

            if ((allowedPermissions.length > 0) &&
                (intersect(allowedPermissions, ownedPermissions).length === 0)) {
                return null;
            }

            return (
                <WrappedComponent {...this.props} />
            );
        }
    };
};

export default withAuthorization;
```

### Authorization Component

```js
import React, { PureComponent } from 'react';
import intersect from 'lodash.intersect';
import ensureArray from 'lib/ensure-array';

class Authorization extends PureComponent {
    static propTypes = {
        allowedRoles: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
        allowedPermissions: PropTypes.oneOfType([PropTypes.string, PropTypes.array])
    };

    // The context will be passed from the topmost container.
    static contextTypes = {
        authorization: PropTypes.shape({
            user: PropTypes.shape({
                name: PropTypes.string.isRequired,
                role: PropTypes.string.isRequired,
                ownedPermissions: PropTypes.array
            })
        })
    };

    render() {
        const {
            user: {
                role,
                ownedPermissions
            }
        } = this.context.authorization;
        
        const allowedRoles = ensureArray(this.props.allowedRoles);
        const allowedPermissions = ensureArray(this.props.allowedPermissions);
            
        if ((allowedRoles.length > 0) && !allowedRoles.includes(role)) {
            return null;
        }

        if ((allowedPermissions.length > 0) &&
            (intersect(allowedPermissions, ownedPermissions).length === 0)) {
            return null;
        }
        
        return this.props.children;
    }
}
```

### Examples

#### withAuthorization (HOC)

```js
const Admin = withAuthorization(['admin']);
const User = withAuthorization(['user', 'admin']);
const PowerUser = withAuthorization(['user', 'admin'], ['read', 'write', 'exec']);

<Router>
    <div>
        <Route path="dashboard" component={User(DashboardContainer)} />
        <Route path="devices" component={User(DevicesContainer)}>
            <Route path="policy" component={PowerUser(PolicyContainer)} />
        </Route>
        <Route path="license" component={Admin(LicenseContainer)}>
    </div>
</Router>
```

#### Authorization Component

```js
const User = (props) => (
    <Authorization allowedRoles={['user', 'admin']}>
        {props.children}
    </Authorization>
);

const PowerUser = (props) => (
    <Authorization allowedRoles={['user', 'admin']} allowedPermissions={['read', 'write', 'exec']}>
        {props.children}
    </Authorization>
);

<User>
    <Component />
</User>

<PowerUser>
    <Component />
</PowerUser>
```

## jQuery Plugin

https://github.com/cheton/rbac

Assuming you have the following HTML file:

```html
<div class="content">
    <div data-rbac-roles="administrator,moderator">
        <p>Only administrator or moderator have permission to view this page.</p>
    </div>
    <div data-rbac-permissions="delete resources">
        <p>You have permission to delete resources.</p>
    </div>
</div>
```

you can define the roles and permissions:

```js
rbac.init({
    role: "administrator",
    rules: {
        "administrator": {
            permissions: [
                "delete resources"
            ],
            inherits: ["moderator"]
        },
        "moderator": {
            permissions: [
                "edit resources",
                "add resources"
            ],
            inherits: ["guest"]
        },
        "guest": {
            permissions: [
                "view resources"
            ],
            inherits: []
        }
    }
});

rbac.role(); 
// "administrator"

rbac.permissions();
// ["delete resources", "edit resources", "add resources", "view resources"]

// Remove unauthorized elements from the DOM.
$('.content').rbac();
```
