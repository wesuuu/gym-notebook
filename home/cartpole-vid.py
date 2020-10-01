import gym

if __name__ == '__main__':
    while True:
        env = gym.make('CartPole-v0')
        env = gym.wrappers.Monitor(env, 'recording')
        action = env.action_space.sample() # randomly act
            obs, reward, done, _ = env.step(action)
            total_reward += reward
            total_steps += 1

            if done:
                break

    print(f'Episode one in {total_steps} steps, total_reward {total_reward}')