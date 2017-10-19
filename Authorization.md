## Authorization

### Store

```js
{
    user: {
        name: 'John Doe',
        role: 'admin', // admin|user|guest
        ownedPermissions: ['read', 'write', 'exec'] // Not defined yet
   }
}
```

### withAuthorization HoC

```js
import React, { PureComponent } from 'react';
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

            if ((allowedPermissions.length > 0) && (intersect(allowedPermissions, ownedPermissions).length === 0)) {
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

#### Example

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

### Authorization Component

```js
import React, { PureComponent } from 'react';
import ensureArray from 'lib/ensure-array';

class Authorization extends PureComponent {
    static propTypes = {
        allowedRoles: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
        allowedPermissions: PropTypes.oneOfType([PropTypes.string, PropTypes.array])
    };

    // The context is passed from the topmost parent container.
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

        if ((allowedPermissions.length > 0) && (intersect(allowedPermissions, ownedPermissions).length === 0)) {
            return null;
        }
        
        return this.props.children;
    }
}
```

#### Example

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
