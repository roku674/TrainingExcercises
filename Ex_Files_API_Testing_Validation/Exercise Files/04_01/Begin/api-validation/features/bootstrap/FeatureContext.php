<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context
{
    protected $response = null;
    protected $username = null;
    protected $password = null;
    protected $client   = null;

    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     * @param array $parameters
     */
    public function __construct($github_username, $github_password)
    {
        $this->username = $github_username;
        $this->password = $github_password;
    }

    /**
     * @Given I am an anonymous user
     */
    public function iAmAnAnonymousUser()
    {
        return true;
    }

    /**
     * @When I search for :arg1
     */
    public function iSearchFor($arg1)
    {
        $client = new GuzzleHttp\Client(['base_uri' => 'https://api.github.com']);
        $this->response = $client->get('/search/repositories?q=' . $arg1);
    }

    /**
     * @Then I expect a :arg1 response code
     */
    public function iExpectAResponseCode($arg1)
    {
        $response_code = $this->response->getStatusCode();
        if ($response_code <> $arg1) {
            throw new Exception("It didn't work. We expected a $arg1 response code but got a " . $response_code);
        }
    }

    /**
     * @Then I expect at least :arg1 result
     */
    public function iExpectAtLeastResult($arg1)
    {
        $data = $this->getBodyAsJson();
        if ($data['total_count'] < $arg1) {
            throw new Exception("We expected at least $arg1 results but found: " . $data['total_count']);
        }
    }

    /**
     * @Given I am an authenticated user
     */
    public function iAmAnAuthenticatedUser()
    {
        $this->client = new GuzzleHttp\Client(
            [
                'base_uri' => 'https://api.github.com',
                'auth' => [$this->username, $this->password]
            ]
        );
        $this->response = $this->client->get('/');

        $this->iExpectAResponseCode(200);
    }

    /**
     * @When I request a list of my repositories
     */
    public function iRequestAListOfMyRepositories()
    {
        $this->response = $this->client->get('/user/repos');

        $this->iExpectAResponseCode(200);
    }

    /**
     * @Then The results should include a repository name :arg1
     */
    public function theResultsShouldIncludeARepositoryName($arg1)
    {
        $repositories = $this->getBodyAsJson();

        foreach($repositories as $repository) {
            if ($repository['name'] == $arg1) {
                return true;
            }
        }

        throw new Exception("Expected to find a repository named '$arg1' but didn't.");
    }

    protected function getBodyAsJson()
    {
        return json_decode($this->response->getBody(), true);
    }
}
