import { h, render, FunctionComponent } from 'preact';
import Logo from '../../components/Logo';

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
    <h1>
      <div className='logo_containter'>
        <Logo logo_url={logo_url} />
      </div>
    </h1>
  );
}
