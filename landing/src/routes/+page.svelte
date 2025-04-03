<script lang="ts">
	import { SiGithub } from '@icons-pack/svelte-simple-icons';
	import { env } from '$env/dynamic/public';

	let email: string = $state('');

	async function handleSignup() {
		const backend = env.PUBLIC_API_URL;
		if (!backend) {
			alert('Backend URL is not defined');
			console.error('Backend URL is not defined');
			return;
		}

		try {
			const resp = await fetch(`${backend}/email-list`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ email })
			});
			if (resp.status !== 200) {
				alert('Error signing up for email list');
				console.error('Error signing up for email list', resp);
				return;
			}
			alert('Successfully signed up for email list!');
		} catch (e) {
			alert('Error signing up for email list');
			console.error('Error signing up for email list', e);
		}
	}
</script>

<div class="flex h-dvh items-center">
	<div class="flex w-full flex-col items-center">
		<div class="flex w-full max-w-[600px] flex-col items-center gap-6 px-4">
			<div class="flex flex-col items-center">
				<h1 class="sign neon-text-blue text-5xl font-medium tracking-widest sm:text-8xl">Boshi</h1>
				<h1
					class="sign neon-text-blue mt-16 text-center text-2xl font-medium tracking-widest sm:text-4xl"
				>
					Under <span class="flicker sign">Construction</span>
				</h1>
			</div>
			<div class="mt-16 flex w-full max-w-[550px] flex-col items-center gap-4">
				<h1 class="text-center text-lg font-extralight text-gray-300 sm:text-xl">
					Connect, share, and explore campus life — <span class="italic">anonymously</span>.
				</h1>
				<h1 class="text-center text-lg font-extralight text-gray-300 sm:text-xl">
					Get notified when the <span class="italic">only</span>
					university social media built on the
					<a href="https://bsky.social/about/blog/10-18-2022-the-at-protocol" target="_blank"
						><span class="neon-text-blue">at protocol</span></a
					> is ready.
				</h1>
			</div>

			<div class="flex w-full flex-col items-center gap-1">
				<div class="my-2 flex w-full max-w-[500px]">
					<input
						type="text"
						class="grow rounded-lg border-2 border-solid border-gray-700 bg-black px-2.5 py-2 text-gray-300 focus:outline-2 focus:outline-blue-700"
						placeholder="Enter email..."
						bind:value={email}
					/>
					<button
						class="transition-duration-200 ml-3 cursor-pointer rounded-lg border-2 border-solid border-blue-300 bg-black px-4 py-2 text-violet-300 drop-shadow-[0_0_6px_var(--color-blue-300)] transition-colors hover:bg-blue-950"
						onclick={handleSignup}
					>
						<span class="btn-text text-sm text-blue-300 sm:text-base">Notify Me</span>
					</button>
				</div>
				<h1 class="text-sm font-extralight text-gray-300 sm:text-base">Unsubscribe at any time.</h1>
			</div>

			<div class="mt-6">
				<a href="https://github.com/matt-dz/boshi" target="_blank">
					<SiGithub color="white" />
				</a>
			</div>
		</div>
	</div>
</div>

<style lang="postcss">
	.sign {
		font-family: 'Monoton', serif;
	}

	.btn-text {
		filter: drop-shadow(0, 0, 1px, currentcolor);
	}

	.neon-text-blue {
		color: #fff;
		text-shadow:
			0 0 7px #fff,
			0 0 10px #fff,
			0 0 21px #fff,
			0 0 42px var(--neon-blue),
			0 0 82px var(--neon-blue),
			0 0 92px var(--neon-blue),
			0 0 102px var(--neon-blue),
			0 0 151px var(--neon-blue);
	}

	.neon-text-blue {
		color: #fff;
		text-shadow:
			0 0 7px #fff,
			0 0 10px #fff,
			0 0 21px var(--neon-blue),
			0 0 42px var(--neon-blue),
			0 0 82px var(--neon-blue),
			0 0 92px var(--neon-blue);
	}

	@keyframes pulsate-blue {
		100% {
			/* Larger blur radius */
			text-shadow:
				0 0 4px #fff,
				0 0 11px #fff,
				0 0 19px #fff,
				0 0 40px var(--neon-blue),
				0 0 80px var(--neon-blue),
				0 0 90px var(--neon-blue),
				0 0 100px var(--neon-blue),
				0 0 150px var(--neon-blue);
		}
		0% {
			/* Smaller blur radius */
			text-shadow:
				0 0 2px #fff,
				0 0 4px #fff,
				0 0 6px #fff,
				0 0 10px var(--neon-blue),
				0 0 45px var(--neon-blue),
				0 0 55px var(--neon-blue),
				0 0 70px var(--neon-blue),
				0 0 80px var(--neon-blue);
		}
	}

	.flicker {
		animation: flicker-yellow 1.5s infinite alternate;
	}

	@keyframes flicker-yellow {
		0%,
		18%,
		22%,
		25%,
		53%,
		57%,
		100% {
			text-shadow:
				0 0 7px #fff,
				0 0 10px #fff,
				0 0 21px var(--neon-blue),
				0 0 42px var(--neon-blue),
				0 0 82px var(--neon-blue),
				0 0 92px var(--neon-blue);
		}
		20%,
		24%,
		55% {
			text-shadow: none;
		}
	}
</style>
