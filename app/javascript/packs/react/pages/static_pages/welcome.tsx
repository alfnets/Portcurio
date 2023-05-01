import { h, render, FunctionComponent, Fragment } from 'preact';
import Logo from '../../components/Logo';
import { Link, route } from 'preact-router';
import { ChangeEvent, useState } from 'preact/compat';

document.addEventListener("DOMContentLoaded", () => {
  const appPropsElement = document.getElementById("app-props") as HTMLElement;
  const props: WelcomeProps = JSON.parse(
    appPropsElement.dataset["props"]
  );
  render(
    <div className="row welcome_container">
      <div className='center jumbotron col-md-12'>
        <div className='center col-md-5 col-md-offset-1'>
          <WelcomeContent props={props} />
        </div>
        <div class="center col-md-5">
          <LoginForm />
        </div>
      </div>
    </div>
    , document.getElementById('app-root') as HTMLElement
  );
});

type WelcomeProps = {
  readonly logo_url: string;
};

const WelcomeContent: FunctionComponent<{ 
  props: WelcomeProps
}> = ({ props }) => {
  const logo_url = props.logo_url;

  return (
    <Fragment>
      <h1>
        <div className='logo_containter'>
          <Logo logo_url={logo_url} />
        </div>
      </h1>
      <div className="top_description">
        <p>
          <strong>Portcurio</strong>（ポートキュリオ）は世界中の教材を集約し、協力してブラッシュアップしていくことを目的としています。ご自身の教材のポートフォリオとしても活用してください。詳しくは<Link href="https://alfnets.info/web-dev05/" target="_blank" rel="noopener noreferrer">コチラ</Link>。
        </p>
      </div>
    </Fragment>
  );
}

const LoginForm: FunctionComponent = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);

  // const handleEmailChange = (e: ChangeEvent<HTMLInputElement>) => {
  //   setEmail(e.target.value);
  // }

  // const handlePasswordChange = (e: ChangeEvent<HTMLInputElement>) => {
  //   setPassword(e.target.value);
  // }

  const handleSubmit = (e: Event) => {
    e.preventDefault();
    console.log("email: " + email);
  }

  // const handleEasyLogin = (userId) => {
  //   console.log("userId: " + userId);
  // }

  return (
    <div className="login_container">
      <form onSubmit={(e: Event) => handleSubmit(e)} className="text-left">
        <label for="email">Email</label>
        <input
          className="form-control"
          type="email"
          name="email"
          placeholder="Email"
          value={email}
          onInput={(e: Event) => setEmail((e.target as HTMLInputElement).value)}
          required
        />

        <label for="password">Password</label>
        <input
          id="password"
          className="form-control password-form"
          type="password"
          name="password"
          placeholder="Password"
          value={password}
          onInput={(e: Event) => setPassword((e.target as HTMLInputElement).value)}
        />

        <div class="login_checkbox">
          <label>
            <input
              type="checkbox"
              className="inline-block"
              checked={rememberMe}
              onChange={() => setRememberMe(!rememberMe)}
            />
            <span>Remember me on this computer</span>
          </label>
        </div>

        <button type="submit" class="btn btn-lg btn-primary">
          Log in
        </button>

        <div class="forgot_link">
          <a onClick={() => route('/new_password_reset')}>forgot password</a>
        </div>
      </form>
    </div>
  )
}
