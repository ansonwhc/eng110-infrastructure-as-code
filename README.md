# Infrastructure as Code (IaC)
IaC is the management of infrastructure, such as networks, VMs, and load balancers, in a descriptive model, using a set of pre-set instructions and commands. An IaC model generates the same environment every time it is applied. 

The servers can be configured by using one of the two methods.  
- Push method: The controlling server pushes the configuration to the destination system.

- Pull method: the to be configured server pulls its configuration from the controlling server.

Ansible guide [here](ansible-guide.md)  

![](/images/infrastructure-as-code.png)

## Benefits
- Testing/Running applications in production-like environment early in the development cycle to prevent common deployment issues
- Stable and reliable environments can be delivered rapidly at scale
- Environment consistency
- Repeatable
- Prevent configuration drift and missing dependencies

## Tools for IaC
- Terraform
- Ansible
- AWS CloudFormation
- Azure Resource Manager
- Chef

![](images/Screenshot%202022-05-17%20105906.png)

## Configuration management and Orchestration under IaC
- Configuration management is a way to configure the software and systems on a machine, such as by installing applications, updates, opening up ports, ensuring services are stopped or started. Its purpose is to bring consistency in the infrastructure.

- Orchestration is designed to automate the deployment of the infrasructure. It arranges and coordinates multiple systems, by specifying when to run which tasks. For example, Ansible is an open-source tool that allows the controller to run adhoc commands by design across multiple machines, which is very useful for completing orchestration tasks.

## Example
IaC can solve the problem of environment drift in the release pipeline. Environment drift is when different teams maintaining and configuring their own environment, and over time, each environment has an unique configuration that is different to the ones used in the other teams. This inconsistency among environments leads to issues during deployment. This manual process is hard to track and likely to cause errors.

Idempotence is a principle of Infrastructure as Code that it always sets the target environment into the same configuration, regardless of the environment's starting state. 

With IaC, teams can make changes to the environment description and version the congiuration model easily, usually using JSON.

### Resources
- https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code  
- https://bluelight.co/blog/best-infrastructure-as-code-tools  
- https://www.atlassian.com/microservices/cloud-computing/infrastructure-as-code#:~:text=IaC%20is%20a%20form%20of,version%20control%20system%20like%20Git.
- https://blog.datanextsolutions.com/infrastructure-as-code-iac-and-configuration-management-cm-583be1687c6d
