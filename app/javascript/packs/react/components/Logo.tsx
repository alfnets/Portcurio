import { h, FunctionComponent } from 'preact';

const Logo: FunctionComponent<{
  logo_url: string;
}> = ({logo_url}) => {
  return (
    <img
      src={logo_url}
      alt="Portcurio"
      width="100%"
    />
  );
};

export default Logo;
